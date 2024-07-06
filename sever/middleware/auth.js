const jwt = require('jsonwebtoken');
const User = require('../models/User');

const auth = async (req, res, next) => {
  try {
    const token = req.header('Authorization').replace('Bearer ', '');
    const decoded = jwt.verify(token, 'secretkey');
    const user = await User.findOne({ _id: decoded._id, 'tokens.token': token });

    if (!user) {
      throw new Error();
    }

    req.user = user;
    req.token = token;
    next();
  } catch (error) {
    if (error.name === 'TokenExpiredError') {
        return res.status(401).send({ error : "Token Expiration",message: '토큰이 만료되었습니다. 다시 로그인하세요.' });
      }
    res.status(401).send({ error: 'Please authenticate.' });
  }
};

module.exports = auth;
