const express = require('express');
const router = express.Router();
const ContatoController = require('../controllers/ContatoEmergenciaController');
const authMiddleware = require('../middlewares/authMiddleware');

router.post('/', authMiddleware, ContatoController.criar);
router.get('/', authMiddleware, ContatoController.listar);
router.put('/:id', authMiddleware, ContatoController.editar);
router.delete('/:id', authMiddleware, ContatoController.deletar);

module.exports = router;