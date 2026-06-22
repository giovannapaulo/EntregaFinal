require('dotenv').config();
const express = require('express');
const cors = require('cors'); 
const { sequelize } = require('./src/models'); 
const localRoutes = require('./src/routes/localRoutes');
const authRoutes = require('./src/routes/authRoutes');
const sintomaRoutes = require('./src/routes/sintomaRoutes'); 
const contatoRoutes = require('./src/routes/contatoRoutes'); 
const meditacaoRoutes = require('./src/routes/meditacaoRoutes');
const somRoutes = require('./src/routes/somRoutes');
const artigoRoutes = require('./src/routes/artigoRoutes');
const lembreteRoutes = require('./src/routes/lembreteRoutes');
const sessaoRoutes = require('./src/routes/sessaoRoutes');

const app = express();
app.use(cors()); 
app.use(express.json());

app.use('/locais', localRoutes); 
app.use('/auth', authRoutes);
app.use('/sintomas', sintomaRoutes); 
app.use('/contatos', contatoRoutes);
app.use('/meditacoes', meditacaoRoutes);
app.use('/sons', somRoutes);
app.use('/artigos', artigoRoutes);
app.use('/lembretes', lembreteRoutes);
app.use('/sessoes', sessaoRoutes);
app.use('/uploads', express.static('uploads'));

app.get('/', (req, res) => res.send('SensivApp API rodando!'));

const PORT = 3000;

sequelize.sync({ force: false }).then(() => {
    console.log('Banco de dados conectado com sucesso!');
    app.listen(PORT, () => console.log(`Servidor rodando na porta ${PORT}`));
}).catch((err) => {
    console.error('Erro ao conectar ao banco de dados:', err);
});