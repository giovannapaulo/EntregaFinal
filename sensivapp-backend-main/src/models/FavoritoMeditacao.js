const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const FavoritoMeditacao = sequelize.define('FavoritoMeditacao', {
    id_paciente: { type: DataTypes.INTEGER, primaryKey: true, references: { model: 'Pacientes', key: 'id_usuario' } },
    id_meditacao: { type: DataTypes.INTEGER, primaryKey: true, references: { model: 'Meditacoes', key: 'id_meditacao' } }
}, { tableName: 'Favoritos_Meditacoes', timestamps: false });

module.exports = FavoritoMeditacao;