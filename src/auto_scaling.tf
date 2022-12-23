resource "aws_appautoscaling_target" "target" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.cluster.name}/${aws_ecs_service.app.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = 1
  max_capacity       = 10
}

resource "aws_appautoscaling_policy" "request_per_target" {
  name               = "app_scale"
  policy_type        = "TargetTrackingScaling"
  service_namespace  = aws_appautoscaling_target.target.service_namespace
  resource_id        = aws_appautoscaling_target.target.resource_id
  scalable_dimension = aws_appautoscaling_target.target.scalable_dimension

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label = "app/${aws_alb.main.name}/${basename("${aws_alb.main.id}")}/targetgroup/${aws_alb_target_group.app.name}/${basename("${aws_alb_target_group.app.id}")}"
    }
    target_value = 10
  }

  depends_on = [aws_appautoscaling_target.target]
}
