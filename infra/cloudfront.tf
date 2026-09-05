resource "aws_cloudfront_distribution" "site" {
  enabled             = true
  default_root_object = "index.html"
  aliases             = ["aws.sangharshjadhav.com"]

  origin {
    domain_name              = aws_s3_bucket.site.bucket_regional_domain_name
    origin_id                = "s3-site-origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.site.id
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "s3-site-origin"
    viewer_protocol_policy = "redirect-to-https"

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.directory_index.arn
    }

    forwarded_values {
      query_string = false
      cookies { forward = "none" }
    }
  }

  restrictions {
    geo_restriction { restriction_type = "none" }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.site.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  custom_error_response {
    error_code         = 404
    response_code      = 404
    response_page_path = "/404.html"
  }
}

resource "aws_cloudfront_function" "directory_index" {
  name    = "aws-cert-showcase-directory-index"
  runtime = "cloudfront-js-2.0"
  comment = "Rewrite directory URLs to Zola index files"
  publish = true

  code = <<-EOT
    function handler(event) {
      var request = event.request;
      var uri = request.uri;

      if (uri.endsWith('/')) {
        request.uri = uri + 'index.html';
      } else if (!uri.includes('.')) {
        request.uri = uri + '/index.html';
      }

      return request;
    }
  EOT
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.site.domain_name
}
