require("@rails/ujs").start()
require("@rails/activestorage").start()

var jQuery = require("jquery");
global.$ = global.jQuery = jQuery;
window.$ = window.jQuery = jQuery;

import '../../assets/stylesheets/application'
import 'bootstrap/dist/js/bootstrap'
import './gallery'
import './ekko-lightbox'
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
