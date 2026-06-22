const express = require('express');
const router = express.Router();
const MeditacaoController = require('../controllers/MeditacaoController');
const authMiddleware = require('../middlewares/authMiddleware');

router.get('/favoritos', authMiddleware, MeditacaoController.listarFavoritos);

router.get('/', authMiddleware, MeditacaoController.listar);

router.post('/:id/favoritar', authMiddleware, MeditacaoController.favoritar);
router.delete('/:id/desfavoritar', authMiddleware, MeditacaoController.desfavoritar);

module.exports = router;