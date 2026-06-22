const express = require('express');
const router = express.Router();
const { UsuarioController, upload } = require('../controllers/UsuarioController');

router.get('/:id', UsuarioController.getPerfil);

router.put('/:id', UsuarioController.atualizarPerfil);

router.post('/:id/foto', upload.single('foto'), UsuarioController.uploadFoto);

module.exports = router;