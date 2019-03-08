# ghidra-docker

This is a dockerized version of Ghidra server meant for multi-user projects.  By
default, it stays within whatever memory limits are set set in Docker or
Kubernetes on the container (via the [container
awareness](https://blog.docker.com/2018/04/improved-docker-container-integration-with-java-10/)
in Java 10+).  Instead of running Ghidra's Linux service, this container runs
the Ghidra server directly, and is configured to log to stdout.

## Docker

If you want to have a user created on first start with the default password of
'changeme', set `GHIDRA_DEFAULT_USERS` to the comma-separated usernames.

For example, to run the container with a memory limit of 1GB and create users
named `esfried` and `ghidra`, use:

```bash
docker run -it --rm -m 1G --env GHIDRA_DEFAULT_USERS=esfried,ghidra bskaggs/ghidra
```

## Helm

There is also a helm chart for kubernetes in the [charts/ghidra-server charts
directory](/charts/ghidra-server) that will create a one-pod StatefulSet with a
persistent volume for storing the repository information.

## Headless Analysis

You can use Ghidra for headless analysis; be sure to read
`support/analyzeHeadlessREADME.html` in the Ghidra distribution to find out
more.

Usernames are by default based on the OS user name, so it's easiest to make one for
your current user, and one for `ghidra` for headless analysis in a docker
container.  However, if you'd like, you can change your user name when launching
the Ghidra by setting the following environment variable:

```bash
VMARGS=-Duser.name=esfried
```

To create the initial repository on the server, you must currently connect once
via the GUI (instructions will change once source code is released).  Create the
shared `foo` project using your name, and make sure to let the "ghidra" user have
Read/Write access.  

Supposing that Ghidra server container you created is running with the IP
address on the docker bridge of 172.17.0.2, you can then launch an analyzer
container mounting in, for example, `/usr/bin` on the host as `/data`, and then
analyze every binary in the directory:

```bash
echo changeme | docker run -i --rm -v -m 4G /usr/bin:/data bskaggs/ghidra \
     support/analyzeHeadless ghidra://172.17.0.2/foo -p -import /data
```
