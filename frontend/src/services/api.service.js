import axios from "axios";
import authHeader from "./auth-header";
import router from "../router";
import store from "../store";

const API_URL = "http://localhost:8080/api/v1/";

axios.interceptors.response.use(
  function (response) {
    return response;
  },
  function (error) {
    if (error.response && error.response.status === 401) {
      router.push("/unauth");
      store.dispatch("auth/logout");
    }
    return Promise.reject(error);
  }
);

class ApiSerivce {
  getMatchById(id) {
    return axios.get(API_URL + "matches/" + id, { headers: authHeader() });
  }
  getMatches(page, pageSize, sort) {
    return axios.get(`${API_URL}matches`, {
      headers: authHeader(),
      params: {
        page,
        size: pageSize,
        sort,
      },
    });
  }
  getMoney() {
    return axios.post(API_URL + "balance/free", {}, { headers: authHeader() });
  }
  makeBet(amount, ids) {
    const makeBetRequest = {
      amount: amount,
      match_events: ids,
    };
    return axios.post(API_URL + "bets", makeBetRequest, {
      headers: authHeader(),
    });
  }
  getAllBets(page, pageSize, sort) {
    return axios.get(`${API_URL}bets`, {
      headers: authHeader(),
      params: {
        page,
        size: pageSize,
        sort,
      },
    });
  }
  getPokemon(name) {
    return axios.get(API_URL + "pokemon/" + name, { headers: authHeader() });
  }
  getAllTransactions(page, pageSize, sort) {
    return axios.get(`${API_URL}transaction`, {
      headers: authHeader(),
      params: {
        page,
        size: pageSize,
        sort,
      },
    });
  }
  donateToAnt(amount) {
    const withdrawRequest = {
      amount: amount,
    };
    return axios.post(API_URL + "balance/withdraw", withdrawRequest, {
      headers: authHeader(),
    });
  }
  changeEventStatus(id, status) {
    const changeEventRequest = {
      id: id,
      status: status,
    };
    return axios.put(API_URL + "events/change", changeEventRequest, {
      headers: authHeader(),
    });
  }
  createCountry(name) {
    const createCountryRequest = {
      name: name,
    };
    return axios.post(API_URL + "country", createCountryRequest, {
      headers: authHeader(),
    });
  }
  createLeague(name, start_date, end_date) {
    const createLeagueRequest = {
      name: name,
      startDate: start_date,
      endDate: end_date
    };
    return axios.post(API_URL + "league", createLeagueRequest, {
      headers: authHeader(),
    });
  }
  addPlayer(name, health, damage, defense, countryId) {
    const createPokemonRequest = {
      name: name,
      health: health,
      damage: damage,
      defense: defense,
      countryId: countryId
    };
    return axios.post(API_URL + "pokemon", createPokemonRequest, {
      headers: authHeader(),
    });
  }
  addMatch(player1Id, player2Id, date, leagueId, countryId) {
    const createMatchRequest = {
      firstPlayerId: player1Id,
      secondPlayerId: player2Id,
      date: date,
      leagueId: leagueId,
      countryId: countryId
    };
    return axios.post(API_URL + "matches", createMatchRequest, {
      headers: authHeader(),
    });
  }
  addMatchEvent(matchId, name, coefficient) {
    const createMatchEventRequest = {
      matchId: matchId,
      name: name,
      coefficient: coefficient,
      status: "TBD"
    };
    return axios.post(API_URL + "events", createMatchEventRequest, {
      headers: authHeader(),
    });
  }
  getAllPlayers() {
    return axios.get(API_URL + "pokemon", { headers: authHeader() })
  }
  getAllCountries() {
    return axios.get(API_URL + "country", { headers: authHeader() })
  }
  getAllLeagues() {
    return axios.get(API_URL + "league", { headers: authHeader() })
  }
  async getRandomPokemonImage() {
    const randomId = Math.floor(Math.random() * 1010) + 1;
    const response =  await axios.get(`https://pokeapi.co/api/v2/pokemon/${randomId}`);
    return response.data.sprites.other["official-artwork"].front_default;
  }
}

export default new ApiSerivce();
