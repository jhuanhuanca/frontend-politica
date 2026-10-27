import { createPinia } from 'pinia'
import { createApp } from 'vue'
import App from './App.vue'
import { reveal } from './directives/reveal'
import { router } from './router'
import './style.css'

const app = createApp(App)
app.directive('reveal', reveal)
app.use(createPinia())
app.use(router)
app.mount('#app')
