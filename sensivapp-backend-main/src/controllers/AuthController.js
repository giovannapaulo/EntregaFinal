const { Usuario, Paciente } = require('../models');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

const SECRET = process.env.JWT_SECRET;

const AuthController = {
    async registrar(req, res) {
        try {
            const { email, senha, nome } = req.body;

            if (!email || !senha || !nome) {
                return res.status(400).json({ error: 'Nome, email e senha são obrigatórios.' });
            }

            const usuarioExistente = await Usuario.findOne({ where: { email } });
            if (usuarioExistente) return res.status(400).json({ error: 'Email já cadastrado.' });

            const senhaHash = await bcrypt.hash(senha, 10);

            const novoUsuario = await Usuario.create({ 
                email, 
                senha: senhaHash,
                nome: nome, 
                tipo_usuario: 'paciente' 
            });

            await Paciente.create({ 
                id_usuario: novoUsuario.id_usuario, 
                nome: nome 
            });

            return res.status(201).json({ message: 'Paciente cadastrado com sucesso!' });
        } catch (error) {
            return res.status(500).json({ error: 'Erro ao cadastrar: ' + error.message });
        }
    },

    async logar(req, res) {
        try {
            const { email, senha } = req.body;

            const usuario = await Usuario.findOne({ where: { email } });
            if (!usuario) return res.status(401).json({ error: 'Credenciais inválidas.' });

            const senhaValida = await bcrypt.compare(senha, usuario.senha);
            if (!senhaValida) return res.status(401).json({ error: 'Credenciais inválidas.' });

            const token = jwt.sign({ id: usuario.id_usuario }, SECRET, { expiresIn: '24h' });

            return res.json({ 
                token, 
                usuario: { id: usuario.id_usuario, email: usuario.email } 
            });
        } catch (error) {
            return res.status(500).json({ error: 'Erro no login: ' + error.message });
        }
    }
};

module.exports = AuthController;