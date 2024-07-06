FROM node:18

# 앱 디렉토리 생성
WORKDIR /usr/src/app

# 앱 의존성 설치
COPY package*.json ./
RUN npm install

# 앱 소스 복사
COPY . .

# 포트 노출
EXPOSE 3000

# 앱 실행
CMD [ "npm", "start" ]