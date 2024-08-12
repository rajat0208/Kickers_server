import jwt from 'jsonwebtoken';

const JWT_SECRET = process.env.JWT_SECRET;

const authenticateToken = (req, res, next) => {
  let token = req.headers['authorization'];
  let tokenParts = token.split(" ")
  token = tokenParts.pop()
  if (!token) {
    return res.status(401).json({ error: 'Authentication token is required' });
  }
  jwt.verify(token, JWT_SECRET, (err, user) => {
    if (err) {
      return res.status(403).json({ error: 'Invalid token' });
    }
    req.user = user;
    next();
  });
};

export default authenticateToken;
