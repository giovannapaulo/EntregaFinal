const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const FavoritoArtigo = sequelize.define('FavoritoArtigo', {
    id_paciente: { type: DataTypes.INTEGER, primaryKey: true, references: { model: 'Pacientes', key: 'id_usuario' } },
    id_artigo: { type: DataTypes.INTEGER, primaryKey: true, references: { model: 'Artigos', key: 'id_artigo' } }
}, { tableName: 'Favoritos_Artigos', timestamps: false });

module.exports = FavoritoArtigo;