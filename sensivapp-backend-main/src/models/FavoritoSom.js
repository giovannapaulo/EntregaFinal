const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const FavoritoSom = sequelize.define('FavoritoSom', {
    id_paciente: { type: DataTypes.INTEGER, primaryKey: true, references: { model: 'Pacientes', key: 'id_usuario' } },
    id_som: { type: DataTypes.INTEGER, primaryKey: true, references: { model: 'Sons_Relaxantes', key: 'id_som' } }
}, { tableName: 'Favoritos_Sons', timestamps: false });

module.exports = FavoritoSom;