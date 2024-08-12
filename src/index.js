import express from 'express';
import dotenv from 'dotenv';
import cors from 'cors';
import HttpException from './models/http-exception.model.js';
import router from './routes/index.js';

dotenv.config();
const app = express();
const PORT = process.env.PORT || 8001;

// Middleware setup
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

// Main routes
app.use(router);

app.use((err, req, res, next) => {
    console.error('Error handler caught:', err); // Debugging line
    if (err instanceof HttpException) {
      if (err.errors) {
        return res
          .status(err.errorCode)
          .json({ error: err.message, details: err.errors });
      }
      return res.status(err.errorCode).json({ error: err.message });
    }
  
    console.error('Unexpected error:', err); // Debugging line
    res.status(500).json({ error: 'An unexpected error occurred' });
  });
  
// Start server
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
