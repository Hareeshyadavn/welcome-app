FROM python:3.8-slim-buster
RUN apt update && apt install -y iputils-ping telnet dnsutils
WORKDIR /app
COPY . .
RUN pip3 install -r requirements.txt
CMD ["python3", "main.py"]
