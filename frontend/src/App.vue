<template>
  <div id="app">
    <nav class="navbar navbar-expand navbar-dark" style="background-color: #262631;">
      <a href="/" class="navbar-brand">
        <img src="../../../ant.jpg" alt="" width="30" height="30" class="d-inline-block rounded"
          style="margin-left: 20px;">
        PokeBet</a>
      <div class="navbar-nav me-auto">
        <li class="nav-item">
          <router-link to="/main" class="nav-link">
            <font-awesome-icon icon="home" /> Линия
          </router-link>
        </li>
      </div>

      <div v-if="!currentUser" class="navbar-nav ml-auto">
        <li class="nav-item">
          <router-link to="/register" class="nav-link">
            <font-awesome-icon icon="user-plus" /> Регистрация
          </router-link>
        </li>
        <li class="nav-item">
          <router-link to="/login" class="nav-link">
            <font-awesome-icon icon="sign-in-alt" /> Войти
          </router-link>
        </li>
      </div>

      <div v-if="currentUser" class="navbar-nav ml-auto">
        <li class="nav-item">
          <router-link to="/transactions" class="nav-link">
            Транзакции
          </router-link>
        </li>
        <li class="nav-item">
          <router-link to="/history" class="nav-link">
            <font-awesome-icon icon="history" /> История
          </router-link>
        </li>

        <li class="nav-item nav-link">
          Баланс:
          {{ currentUser.balanceAmount }}
        </li>
        <li class="nav-item">
          <router-link to="/profile" class="nav-link">
            <font-awesome-icon icon="user" />
            {{ currentUser.name }}
          </router-link>
        </li>
        <li class="nav-item">
          <a class="nav-link" @click.prevent="logOut">
            <font-awesome-icon icon="sign-out-alt" /> Выход
          </a>
        </li>
      </div>
    </nav>

    <div class="container">
      <div v-if="pagesWithCoupon.includes($route.name)">
        <coupon />
      </div>
      <router-view />
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      pagesWithCoupon: ['match', 'main'],
    }
  },
  computed: {
    currentUser() {
      return this.$store.state.auth.user;
    }
  },
  methods: {
    logOut() {
      this.$store.dispatch('auth/logout');
      this.$router.push('/login');
    }
  }
};
</script>
<style>
#app,
html {
  background-color: #121219;
}

p,
div {
  color: white;
}
</style>
