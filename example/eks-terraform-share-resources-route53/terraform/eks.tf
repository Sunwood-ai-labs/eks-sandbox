# EKSクラスターの設定
# このモジュールは以下の主要コンポーネントを設定します：
# - EKSクラスター本体
# - マネージドノードグループ
# - セキュリティグループ
# - IAMロールと権限
# 
# クラスターはプライベートサブネットにデプロイされ、パブリックエンドポイントも有効化されています。

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.32"

  # VPCとサブネットの設定
  # プライベートサブネットを使用してセキュリティを確保
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # エンドポイントアクセス設定
  # プライベート/パブリックの両方のアクセスを許可  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  # クラスターログの設定
  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  # ノードグループの設定
  # 自動スケーリングとインスタンスタイプの定義
  eks_managed_node_groups = {
    main = {
      name = var.node_group_name

      instance_types = [var.node_instance_type]
      version       = "1.28"

      min_size     = var.node_min_capacity
      max_size     = var.node_max_capacity
      desired_size = var.node_desired_capacity

      # ノードに必要な追加IAMポリシー
      # - ECRアクセス権限（コンテナイメージの取得用）
      iam_role_additional_policies = [
        "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess",
        "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      ]
    }
  }

  # セキュリティグループルール
  # クラスター内部の通信を許可
  cluster_security_group_additional_rules = {
    ingress_nodes_ephemeral_ports_tcp = {
      description                = "Node to cluster access"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "ingress"
      source_node_security_group = true
    }
  }

  # ノード間通信とインターネットアクセスの設定
  # 必要な通信のみを許可
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Allow inter-node communication"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description = "Allow all external communication"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "egress"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  tags = var.default_tags
}
