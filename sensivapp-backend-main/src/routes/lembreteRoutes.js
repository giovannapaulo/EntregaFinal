const express = require('express');
const router = express.Router();
const LembreteController = require('../controllers/LembreteController');
const authMiddleware = require('../middlewares/authMiddleware');

router.get('/', authMiddleware, LembreteController.listar);
router.post('/', authMiddleware, LembreteController.criar);
router.put('/:id', authMiddleware, LembreteController.atualizar);
router.delete('/:id', authMiddleware, LembreteController.deletar);

module.exports = router;