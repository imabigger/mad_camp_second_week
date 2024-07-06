const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

// 스키마 정의
const userSchema = new mongoose.Schema({
  username: {
    type: String,
    required: true,
    trim: true,
  },
  password: {
    type: String,
    required: true,
    trim: true,
    minlength: 6,
  },
  email: {
    type: String,
    required: true,
    unique: true // email의 중복을 방지
  },
  tokens: [
    {
      token: {
        type: String,
        required: true,
      },
    },
  ],
  refreshToken: {
    type: String,
  },
});

// 비밀번호 해싱
userSchema.pre('save', async function (next) {
  const user = this;
  if (user.isModified('password')) {
    user.password = await bcrypt.hash(user.password, 8);
  }
  next();
});

// 사용자 인증
userSchema.statics.findByCredentials = async (username, password) => {
  const user = await User.findOne({ username });
  if (!user) {
    throw new Error('Unable to login');
  }

  const isMatch = await bcrypt.compare(password, user.password);
  if (!isMatch) {
    throw new Error('Unable to login');
  }
  return user;
};

// 인증 토큰 생성
userSchema.methods.generateAuthToken = async function () {
  const user = this;
  const token = jwt.sign({ _id: user._id.toString() }, 'secretkey' , { expiresIn: '1d' });

  user.tokens = user.tokens.concat({ token });
  await user.save();
  return token;
};

// 리프레시 토큰 생성 메서드
userSchema.methods.generateRefreshToken = async function () {
    const user = this;
    const refreshToken = jwt.sign({ _id: user._id.toString() }, 'secretKey', { expiresIn: '7d' });
  
    user.refreshToken = refreshToken;
    await user.save();
  
    return refreshToken;
  };


//Mongoose는 모델 이름(User)의 소문자와 복수형을 사용하여 컬렉션 이름(users)을 자동으로 만듭니다.
const User = mongoose.model('User', userSchema);

module.exports = User;
