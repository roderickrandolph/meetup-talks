# Demo Notes

# Triple R Tracker

## Clone repo

```
git clone git@github.com:roderickrandolph/meetup-talks.git
cd meetup-talks/creating-docker-containers-with-ansible-demo
atom .
cd tripler-tracker
```

## Demo using Dockerfile and Docker Compose

Explain app purpose and files

```
cat app.js
cat Dockerfile
cat docker-compose.yml
```

Build and run the app

```
docker-compose build
docker-compose up
```

Test the app

```
curl -v http://localhost:8888
make test
```

Stop the app

`Ctrl+C`

## Convert app to ansible-container

### Install Ansible Container

Open new terminal window

#### Via pip

This will install the latest stable version

```
pip install ansible-container
```

#### From source

To get the bleeding edge / pre-release version

```
virtualenv venv
source venv/bin/activate
git clone https://github.com/ansible/ansible-container.git
cd ansible-container
python setup.py install
```

Verify installation was successful

```
ansible-container version
ansible-container help
```

Initialize ansible-container

`ansible-container init`

Review the files that were created

```
cat ansible/container.yml
cat ansible/main.yml
cat ansible/requirements.txt
```

Edit ansible/container.yml

```yaml
version: "1"
services:
  app:
    image: node:5.10.1
    ports:
      - 8888:8888
    command: ["node", "/src/app.js"]
    links:
      - redis

  redis:
    image: redis:alpine
    ports:
      - 6379:6379

registries: {}
```

Edit ansible/main.yml

```yaml
- hosts: app
  tasks:
    - name: create sources directory
      file:
        path: /src
        state: directory
        mode: 0755

    - name: copy sources
      copy:
        src: "{{ lookup('pipe', 'dirname `pwd`') }}/{{ item }}"
        dest: "/src/{{ item }}"
      with_items:
        - package.json
        - app.js

    - name: install app
      npm:
        production: yes
        path: /src
        state: latest
```

Build using ansible-container

`ansible-container build`

Build it again to check for idempotency (and with color)

`ansible-container build -e ANSIBLE_FORCE_COLOR=1`

Compare the docker images (sizes)

`docker images "tripler*"`

Run the app

`ansible-container run`

Test it

```
curl -v http://localhost:8888
make test
```

Push it to docker registry

`ansible-container push`

Commit to source control

```
git add ansible
git commit -m "ansible-container rules!"
git push
```

# Jenkins

Let's build Jenkins stack (with some debugging)

```
ansible-container build -e ANSIBLE_FORCE_COLOR=1 -- -vv
ansible-galaxy install -r requirements.yml -p ansible/roles
```

Explain jenkins setup (1 master + 6 slaves), files, galaxy roles

```
cd ../jenkins
cat ansible/container.yml
cat ansible/main.yml
cat requirements.yml
```

I cheated - images were already pre-built

`docker images "jenkins*"`

Start Jenkins stack

`ansible-container run`

Open Jenkins and login

http://localhost:8080

Configure pipeline job

Wait for failure and explain

Stop Jenkins stack (e.g.  Ctrl+C)

Start Jenkins stack with Docker for Mac slave

```
cat slave.sh
cat Makefile
make start-jenkins
```

Wait for Jenkins to start (notice job is still there via a docker volume)

Edit Jenkinsfile and add "&& !dind"

```
git add Jenkinsfile
git commit -m "don't run ansible-container on dind nodes"
git push
```

Rerun Jenkins job
