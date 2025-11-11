const express = require('express');
const app = express();
const port = 3001;

app.use(express.json());

const otpStore = {};

app.post('/generate-otp', (req, res) => {
  const { emailOrMobile } = req.body;

  if (!emailOrMobile) {
    return res.status(400).json({ error: 'Email or mobile number is required' });
  }

  const otp = Math.floor(100000 + Math.random() * 900000).toString();
  otpStore[emailOrMobile] = otp;

  console.log(`OTP for ${emailOrMobile}: ${otp}`);

  res.status(200).json({ message: 'OTP generated and sent', otp: otp }); // Return OTP for testing
});

const jwt = require('jsonwebtoken');
const JWT_SECRET = 'your-super-secret-key'; // In a real app, use an environment variable

app.post('/verify-otp', (req, res) => {
  const { emailOrMobile, otp } = req.body;

  if (!emailOrMobile || !otp) {
    return res.status(400).json({ error: 'Email/mobile and OTP are required' });
  }

  if (otpStore[emailOrMobile] === otp) {
    delete otpStore[emailOrMobile]; // OTPs should be single-use
    const token = jwt.sign({ emailOrMobile }, JWT_SECRET, { expiresIn: '1h' });
    res.status(200).json({ token });
  } else {
    res.status(400).json({ error: 'Invalid OTP' });
  }
});

app.listen(port, () => {
  console.log(`AuthService listening at http://localhost:${port}`);
});
