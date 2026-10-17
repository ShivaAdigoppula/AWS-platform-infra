# 1. TRUST POLICY: who may assume ("wear") this role
data "aws_iam_policy_document" "trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = var.service_principals
    }
  }
}

# 2. THE ROLE itself, with the trust policy attached
resource "aws_iam_role" "this" {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.trust.json
}

# 3. PERMISSIONS: what the role may do (one attachment per policy)
resource "aws_iam_role_policy_attachment" "this" {
  for_each = toset(var.managed_policy_arns)

  role       = aws_iam_role.this.name
  policy_arn = each.value
}

# 4. INSTANCE PROFILE: the "wrapper" EC2 needs to use a role (Day 2: Jenkins)
resource "aws_iam_instance_profile" "this" {
  count = var.create_instance_profile ? 1 : 0

  name = var.name
  role = aws_iam_role.this.name
}