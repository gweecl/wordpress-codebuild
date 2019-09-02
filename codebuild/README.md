# AWS

### CodeBuild

* To allow build environment connect to database / RDS. Make sure its has the right subnets / security groups configured.
* To allow build environment access credential in Secret Manager. Make sure build role has the following policy attached.
  ```
  - Resource: !Ref AppSecretManagerArn
    Effect: Allow
    Action:
      - secretsmanager:GetSecretValue
  ```

### ECS

* WordPress might have slow response. Make sure the healthcheck is configured with longer timeout duration.
