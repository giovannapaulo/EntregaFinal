const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const LocalTag = sequelize.define('LocalTag', {
    id_local: { type: DataTypes.INTEGER, primaryKey: true, references: { model: 'Locais_Conforto', key: 'id_local' } },
    id_tag: { type: DataTypes.INTEGER, primaryKey: true, references: { model: 'Tags', key: 'id_tag' } }
}, { tableName: 'Locais_Tags', timestamps: false });

module.exports = LocalTag;