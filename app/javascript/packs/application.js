require("@rails/ujs").start()
require("@rails/activestorage").start()

var jQuery = require("jquery");
global.$ = global.jQuery = jQuery;
window.$ = window.jQuery = jQuery;

import '../../assets/stylesheets/application'
import 'bootstrap/dist/js/bootstrap'
import './gallery'
import './ekko-lightbox'
import './leaflet'
import ApexCharts from 'apexcharts'
window.ApexCharts = ApexCharts

const images = require.context('../images', true)

window.Aos = require('./aos')

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

// Указать путь к 5 иконкам leaflet
// delete L.Icon.Default.prototype._getIconUrl - эта строка не нужна, наверное...
L.Icon.Default.mergeOptions({
  iconRetinaUrl: require('../images/leaflet_images/marker-icon-2x.png'),
  iconUrl: require('../images/leaflet_images/marker-icon.png'),
  shadowUrl: require('../images/leaflet_images/marker-shadow.png')
})