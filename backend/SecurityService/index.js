const express = require('express');
const app = express();
const port = 3002;

app.use(express.json());

app.post('/log-visitor', (req, res) => {
  const { visitorName, flatNumber, photoUrl } = req.body;

  if (!visitorName || !flatNumber) {
    return res.status(400).json({ error: 'Visitor name and flat number are required' });
  }

  console.log(`Visitor Logged:
    Name: ${visitorName}
    Flat Number: ${flatNumber}
    Photo URL: ${photoUrl || 'N/A'}
    Timestamp: ${new Date().toISOString()}
  `);

  res.status(200).json({ message: 'Visitor logged successfully' });
});

app.listen(port, () => {
  console.log(`SecurityService listening at http://localhost:${port}`);
});
