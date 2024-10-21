<template>
  <div class="position-absolute start-50 w-50 translate-middle-x">
    <div v-for="match in matches" :key="match.id">
      <router-link style="text-decoration: none; color: inherit;" :to="'/match/' + match.id">
        <div class="hovered d-flex flex-row justify-content-between align-items-center rounded-rectangle">
          <img src="../assets/logo.png" alt="" style="height: 2em;">
          <div style="width: 25%;" class="h4 text-center">{{ match.firstPlayerName }}</div>
          <div style="width: 25%;" class="h5 text-center">{{ match.date }}</div>
          <div style="width: 25%;" class="h4 text-center">{{ match.secondPlayerName }}</div>
          <img src="../assets/logo.png" alt="" style="height: 2em;">
        </div>
      </router-link>
    </div>
  </div>
</template>
<script>
import ApiService from "../services/api.service";

export default {
  name: "Main",
  data() {
    return {
      match_id: this.$route.params.id,
      matches: [],
      match_events: [],
      chunkedMatchEvents: []
    };
  },
  methods: {
    getMatches() {
      ApiService.getMatches()
        .then(response => {
          this.matches = response.data.matches;
        })
    },
  },
  mounted() {
    this.getMatches();
  },

};

</script>

<style scoped>
.rounded-rectangle {
  margin-top: 30px;
  background-color: #262630;
  border-radius: 10px;
  padding: 10px;
}

.hovered {
  transition: 0.5s box-shadow;
}

.hovered:hover {
  box-shadow: 0 5px 35px 0px white;
}

@keyframes clockwise {
  0% {
    top: -5px;
    left: 0;
  }

  12% {
    top: -2px;
    left: 2px;
  }

  25% {
    top: 0;
    left: 5px;
  }

  37% {
    top: 2px;
    left: 2px;
  }

  50% {
    top: 5px;
    left: 0;
  }

  62% {
    top: 2px;
    left: -2px;
  }

  75% {
    top: 0;
    left: -5px;
  }

  87% {
    top: -2px;
    left: -2px;
  }

  100% {
    top: -5px;
    left: 0;
  }
}

@keyframes counterclockwise {
  0% {
    top: -5px;
    right: 0;
  }

  12% {
    top: -2px;
    right: 2px;
  }

  25% {
    top: 0;
    right: 5px;
  }

  37% {
    top: 2px;
    right: 2px;
  }

  50% {
    top: 5px;
    right: 0;
  }

  62% {
    top: 2px;
    right: -2px;
  }

  75% {
    top: 0;
    right: -5px;
  }

  87% {
    top: -2px;
    right: -2px;
  }

  100% {
    top: -5px;
    right: 0;
  }
}

button {
  margin-top: 8px;
}
</style>