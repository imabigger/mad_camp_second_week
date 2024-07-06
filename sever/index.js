require('dotenv').config();

const express = require('express');
const mongoose = require('mongoose');
const User = require('./models/User'); // User 모델
const auth = require('./middleware/auth'); // 인증 미들웨어
const axios = require('axios');
const qs = require('qs');
const app = express();
const port = 3000;

// express 서버 설정
app.use(express.json());

// MongoDB 연결
mongoose.connect('mongodb://mongo:27017/mydatabase')
.then(() => console.log('MongoDB connected'))
.catch(err => console.log(err));

// 서버 실행시 메시지 출력
app.listen(port, () => {
    console.log(`Server is running at http://localhost:${port}`);
  });

// 사용자 등록
app.post('/register', async (req, res) => {
    try {
      const { username, password, email } = req.body;
      const user = new User({ username, password, email });
  
      await user.save(); // await를 사용하여 user.save()가 완료될 때까지 기다립니다.
      const token = await user.generateAuthToken();
      const refreshToken = await user.generateRefreshToken();
  
      res.status(201).send({ message: 'User registered successfully' , user, token ,refreshToken});
    } catch (error) {
      if (error.code === 11000) { // MongoDB의 중복 키 오류 코드
        return res.status(400).json({
          error : 'duplicate key',
          message: '사용할 수 없는 아이디 또는 이메일입니다.'
        });
      }
      console.log("POST: 유저 생성 실패", error);
      res.status(500).json({
        message: `create failed: ${error}`
      });
    }
  }
);

// 사용자 로그인
app.post('/login', async (req, res) => {
    try {
      const { username, password } = req.body;
      const user = await User.findByCredentials(username, password);
      const token = await user.generateAuthToken();
      const refreshToken = await user.generateRefreshToken();
      res.send({ user, token, refreshToken});
    } catch (error) {
      res.status(400).send(error);
    }
  });

  // refresh token 으로 token 재발급 로직
app.post('/token', async (req, res) => {
    const { refreshToken } = req.body;

    try {
        const decoded = jwt.verify(refreshToken, 'secretKey');
        const user = await User.findOne({ _id: decoded._id, refreshToken });

        if (!user) {
        throw new Error();
        }

        const newToken = await user.generateAuthToken();
        res.send({ token: newToken });
    } catch (error) {
        if (error.name === 'TokenExpiredError') {
            return res.status(401).send({ error : "Token Expiration",message: '토큰이 만료되었습니다.' });
          }
        res.status(401).send({error : "Invaild Refresh Token" ,message: '리프레시 토큰이 유효하지 않습니다.' });
    }
});
  
  // 보호된 경로 예제
app.get('/protected', auth, (req, res) => {
    res.send('This is a protected route');
});


// 카카오 로그인 콜백
app.get('/auth/kakao/callback', async (req, res) => {
  const { accessstoken } = req.body;

  try {
    const userResponse = await axios.get('https://kapi.kakao.com/v2/user/me', {
      headers: {
        Authorization: `Bearer ${accessstoken}`,
      },
    });

    const userData = userResponse.data;
    const { id, kakao_account } = userData;
    const { email, profile } = kakao_account;
    const { nickname } = profile;

    // 데이터베이스에 유저 정보 저장
    let user = await User.findOne({ email });

    if (!user) {
      user = new User({ username: nickname, email, password: 'kakao' });
      await user.save();
    }

    const token = await user.generateAuthToken();
    const refreshToken = await user.generateRefreshToken();

    res.status(200).send({ user, token, refreshToken });
  } catch (error) {
    console.error(error);
    res.status(500).send('Authentication failed');
  }
});