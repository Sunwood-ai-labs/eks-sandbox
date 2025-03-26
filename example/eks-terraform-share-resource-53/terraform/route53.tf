# Kubernetes Serviceリソース
resource "kubernetes_service" "counter_app" {
  metadata {
    name = "gradio-counter-app-service"
    namespace = "default"
    annotations = {
      "external-dns.alpha.kubernetes.io/hostname" = "counter.${var.domain}"
      "service.beta.kubernetes.io/aws-load-balancer-type" = "nlb"
      "service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled" = "true"
      "service.beta.kubernetes.io/aws-load-balancer-ssl-ports" = "443"
    }
  }
  spec {
    selector = {
      app = "gradio-counter-app"
    }
    port {
      port = 80
      target_port = 7860
    }
    type = "LoadBalancer"
  }

  depends_on = [module.eks]
}

resource "kubernetes_service" "calculator_app" {
  metadata {
    name = "gradio-calculator-app-service"
    namespace = "default"
    annotations = {
      "external-dns.alpha.kubernetes.io/hostname" = "calculator.${var.domain}"
      "service.beta.kubernetes.io/aws-load-balancer-type" = "nlb"
      "service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled" = "true"
      "service.beta.kubernetes.io/aws-load-balancer-ssl-ports" = "443"
    }
  }
  spec {
    selector = {
      app = "gradio-calculator-app"
    }
    port {
      port = 80
      target_port = 7860
    }
    type = "LoadBalancer"
  }

  depends_on = [module.eks]
}

resource "kubernetes_service" "text_app" {
  metadata {
    name = "gradio-text-app-service"
    namespace = "default"
    annotations = {
      "external-dns.alpha.kubernetes.io/hostname" = "text.${var.domain}"
      "service.beta.kubernetes.io/aws-load-balancer-type" = "nlb"
      "service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled" = "true"
      "service.beta.kubernetes.io/aws-load-balancer-ssl-ports" = "443"
    }
  }
  spec {
    selector = {
      app = "gradio-text-app"
    }
    port {
      port = 80
      target_port = 7860
    }
    type = "LoadBalancer"
  }

  depends_on = [module.eks]
}

# データソース: AWS Load Balancers
data "aws_lb" "counter_nlb" {
  tags = {
    "kubernetes.io/service-name" = "default/gradio-counter-app-service"
  }
  depends_on = [kubernetes_service.counter_app]
}

data "aws_lb" "calculator_nlb" {
  tags = {
    "kubernetes.io/service-name" = "default/gradio-calculator-app-service"
  }
  depends_on = [kubernetes_service.calculator_app]
}

data "aws_lb" "text_nlb" {
  tags = {
    "kubernetes.io/service-name" = "default/gradio-text-app-service"
  }
  depends_on = [kubernetes_service.text_app]
}

# Route53レコード
resource "aws_route53_record" "counter" {
  zone_id = var.route53_zone_id
  name    = "counter.${var.domain}"
  type    = "CNAME"
  ttl     = "300"
  records = [data.aws_lb.counter_nlb.dns_name]
  depends_on = [data.aws_lb.counter_nlb]
}

resource "aws_route53_record" "calculator" {
  zone_id = var.route53_zone_id
  name    = "calculator.${var.domain}"
  type    = "CNAME"
  ttl     = "300"
  records = [data.aws_lb.calculator_nlb.dns_name]
  depends_on = [data.aws_lb.calculator_nlb]
}

resource "aws_route53_record" "text" {
  zone_id = var.route53_zone_id
  name    = "text.${var.domain}"
  type    = "CNAME"
  ttl     = "300"
  records = [data.aws_lb.text_nlb.dns_name]
  depends_on = [data.aws_lb.text_nlb]
}
