const express = require('express');
const app = express();
const port = process.env.PORT || 3000;
app.use(express.json());

app.post('/payment/mpesa/callback', (req, res) => {
  console.log('M-Pesa Callback received:', JSON.stringify(req.body));
  res.status(200).json({ ResultCode: 0, ResultDesc: 'Accepted' });
});

app.get('/', (req, res) => res.send('Callback test server running'));

app.listen(port, '0.0.0.0', () => console.log(`Server listening on port ${port}`));
