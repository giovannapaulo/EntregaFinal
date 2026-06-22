const express = require('express');
const cors = require('cors');

const authRoutes = require('./src/routes/authRoutes');
const localRoutes = require('./src/routes/localRoutes');

const app = express();

app.use(cors()); 
app.use(express.json()); 

app.use('/auth', authRoutes);
app.use('/locais', localRoutes);

app.get('/', (req, res) => {
    res.send('SensivApp API rodando com sucesso!');
});

module.exports = app;