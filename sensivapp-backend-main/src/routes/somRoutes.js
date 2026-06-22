const express = require('express');
const router = express.Router();
const SomController = require('../controllers/SomRelaxanteController');
const authMiddleware = require('../middlewares/authMiddleware');

router.get('/', authMiddleware, SomController.listar);
router.get('/favoritos', authMiddleware, SomController.listarFavoritos);
router.post('/:id/favoritar', authMiddleware, SomController.favoritar);
router.delete('/:id/desfavoritar', authMiddleware, SomController.desfavoritar);

module.exports = router;