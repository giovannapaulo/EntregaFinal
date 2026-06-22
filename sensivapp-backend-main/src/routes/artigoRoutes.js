const express = require('express');
const router = express.Router();
const ArtigoController = require('../controllers/ArtigoController');
const authMiddleware = require('../middlewares/authMiddleware');

router.get('/', authMiddleware, ArtigoController.listar);
router.get('/favoritos', authMiddleware, ArtigoController.listarFavoritos);
router.post('/:id/favoritar', authMiddleware, ArtigoController.favoritar);
router.delete('/:id/desfavoritar', authMiddleware, ArtigoController.desfavoritar);

module.exports = router;