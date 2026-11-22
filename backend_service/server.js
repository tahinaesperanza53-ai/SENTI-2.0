const express = require('express');
const cors = require('cors');
const app = express();

app.use(express.json());
app.use(cors());

// Test route
app.get('/', (req, res) => {
  res.send('Are You Ready Learners API is up and running!');
});

// Mock database route for user progress
let userScores = {
  "user123": { stars: 10, completedLevels: [] }
};

app.get('/api/users/:id', (req, res) => {
  const userId = req.params.id;
  res.json(userScores[userId] || { stars: 0, completedLevels: [] });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});