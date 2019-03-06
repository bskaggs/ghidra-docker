# ghidra-docker

This is a dockerized version of Ghidra server meant for multi-user projects.  By default, it stays within whatever memory limits are set set in Docker or Kubernetes on the container (via the [container awareness](https://blog.docker.com/2019/04/improved-docker-container-integration-with-java-10/) in Java 10+).  Instead of running Ghidra's Linux service, this container runs the Ghidra server directly, and is configured to log to stdout.

If you want to have a user created at start with the default password of 'changme', set `GHIDRA_DEFAULT_USER` to the username.

For example, to run the container with a memory limit of 1GB and create a user named `wffried`, use:

```bash
docker run -it --rm -m 1G --env GHIDRA_DEFAULT_USER=wffried bskaggs/ghidra
```

There is also a helm chart in the [ghidra directory](/ghidra) that will create a one-pod StatefulSet with a persistent volume for storing the repository information
