## 构建方法

docker build -t daocloud.io/daocloud/cluster-cleanup:0.1 .

## 最简清理方法

创建 docker 清理的 daemonset
kubectl create -f docker-clean.yaml

更新镜像可以用下面命令：
kubectl  patch daemonset  k8s-cleanup -n kube-system   --type='json' -p='[{"op": "replace", "path": "/spec/template/spec/containers/0/image", "value":"daocloud.io/daocloud/clean-cluster:0.2"}]'

## k8s-cleanup

Here are 3 cleanups you can apply on your kubernetes cluster:
* Cleans up exited containers and dangling images/volumes running as a DaemonSet (`docker-clean.yml`).
* Cleans up old replica sets, finished jobs and unrecycled evicted pods as a CronJob (`k8s-clean.yml`).
* Cleans up empty directory (not used anymore) in etcd as a CronJob (`etcd-empty-dir-cleanup.yml`).

You must have `batch/v2alpha1` enabled on your k8s API server runtime config in order to run the CronJob.

### Env vars
In the DaemonSet (`docker-clean.yml`) you can set `DOCKER_CLEAN_INTERVAL` to modify the interval when it cleans up exited containers and dangling images/volumes; defaults to 30min (1800s).

In the CronJob (`k8s-clean.yml`) you can set `K8S_CLEAN_DAYS` to modify the maximum age of replica sets; defaults to 7 days.

### Deployment

```
kubectl --context CONTEXT -n kube-system apply -f rbac.yml
kubectl --context CONTEXT -n kube-system apply -f docker-clean.yml
kubectl --context CONTEXT -n kube-system apply -f k8s-clean.yml
kubectl --context CONTEXT -n kube-system apply -f etcd-empty-dir-cleanup.yml
```
