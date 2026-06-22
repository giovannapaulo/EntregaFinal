const express = require('express');
const router = express.Router();
const SessaoController = require('../controllers/SessaoController');

router.get('/:id_vinculo', SessaoController.listarPorVinculo);

router.post('/', SessaoController.criarSessao);

module.exports = router;