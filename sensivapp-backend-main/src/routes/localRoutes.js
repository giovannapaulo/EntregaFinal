const express = require('express');
const router = express.Router();
const LocalConfortoController = require('../controllers/LocalConfortoController');
const authMiddleware = require('../middlewares/authMiddleware');

router.post('/', authMiddleware, LocalConfortoController.criar);
router.get('/', authMiddleware, LocalConfortoController.listar);
router.put('/:id', authMiddleware, LocalConfortoController.editar);
router.delete('/:id', authMiddleware, LocalConfortoController.deletar);

module.exports = router;