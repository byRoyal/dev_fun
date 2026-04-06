FROM ubuntu:22.04

RUN apt-get update && apt-get install -y openssh-server && \
    mkdir /var/run/sshd

RUN useradd -m -s /bin/bash admin && \
    useradd -m -s /bin/bash user1 && \
    useradd -m -s /bin/bash user2

RUN echo 'admin:adminpass' | chpasswd admin && \
    echo 'user1:user1pass' | chpasswd user1 && \
    echo 'user2:user2pass' | chpasswd user2

RUN mkdir -p /data/shared /data/admin /data/user1 /data/user2

RUN chown admin:admin /data/admin && chmod 600 /data/admin && \
    chown user1:user1 /data/user1 && chmod 750 /data/user1 && \
    chown user2:user2 /data/user2 && chmod 750 /data/user2

RUN groupadd fileusers && \
    usermod -aG fileusers admin && \
    usermod -aG fileusers user1 && \
    usermod -aG fileusers user2 && \
    usermod -aG user1 admin && \
    usermod -aG user2 admin && \
    usermod -aG root admin && \
    chown admin:fileusers /data/shared && \
    chmod 770 /data/shared

RUN sed -i 's/#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]