<template>
  <div class="position-absolute start-50 w-50 translate-middle-x">
    <div v-for="match in matches" :key="match.id">
      <router-link style="text-decoration: none; color: inherit;" :to="'/match/' + match.id">
        <div class="hovered d-flex flex-row justify-content-between align-items-center rounded-rectangle">
          <img :src="match.randomPokemonImage1" alt="Pokémon 1" style="height: 3em;" />
          <div style="width: 25%;" class="h4 text-center">{{ match.firstPlayerName }}</div>
          <div style="width: 25%;" class="h5 text-center">{{ match.date }}</div>
          <div style="width: 25%;" class="h4 text-center">{{ match.secondPlayerName }}</div>
          <img :src="match.randomPokemonImage2" alt="Pokémon 2" style="height: 3em;" />
        </div>
      </router-link>
    </div>
  </div>
</template>

<script>
import ApiService from "../services/api.service";
import apiService from "@/services/api.service";

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
    async getMatches() {
      try {
        const response = await ApiService.getMatches();
        const matches = response.data.matches.slice().sort((a, b) => {
          const dateA = new Date(a.date);
          const dateB = new Date(b.date);
          return dateA - dateB;
        });

        this.matches = await Promise.all(
            matches.map(async (match) => {
              const randomPokemonImage1 = await this.getRandomPokemonImage();
              const randomPokemonImage2 = await this.getRandomPokemonImage();
              return {
                ...match,
                randomPokemonImage1,
                randomPokemonImage2
              };
            })
        );
      } catch (error) {
        console.error("Error fetching matches or Pokémon images:", error);
      }
    },
    async getRandomPokemonImage() {
      try {
        return await apiService.getRandomPokemonImage();
      } catch (error) {
        console.error("Error fetching Pokémon image:", error);
        return "";
      }
    }
  },
  async mounted() {
    await this.getMatches();
  }
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
