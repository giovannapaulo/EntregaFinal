const Usuario = require('../models/Usuario');
const multer = require('multer');
const path = require('path');

const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, 'uploads/'); 
    },
    filename: (req, file, cb) => {
        cb(null, `user_${Date.now()}${path.extname(file.originalname)}`);
    }
});

const upload = multer({ storage: storage });

const UsuarioController = {
    async getPerfil(req, res) {
        try {
            const usuario = await Usuario.findByPk(req.params.id);
            if (!usuario) return res.status(404).json({ message: "Usuário não encontrado" });
            res.json(usuario);
        } catch (error) {
            res.status(500).json({ message: "Erro ao buscar perfil", error });
        }
    },

    
    async atualizarPerfil(req, res) {
        try {
            const { nome } = req.body;
            await Usuario.update({ nome }, { where: { id_usuario: req.params.id } });
            res.json({ message: "Perfil atualizado com sucesso" });
        } catch (error) {
            res.status(500).json({ message: "Erro ao atualizar perfil", error });
        }
    },

   
    async uploadFoto(req, res) {
        try {
            if (!req.file) return res.status(400).json({ message: "Nenhum arquivo enviado" });
            
            const urlFoto = req.file.path; 
            await Usuario.update({ url_foto: urlFoto }, { where: { id_usuario: req.params.id } });
            
            res.json({ message: "Foto atualizada!", path: urlFoto });
        } catch (error) {
            res.status(500).json({ message: "Erro no upload", error });
        }
    }
};

module.exports = { UsuarioController, upload };