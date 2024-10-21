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
  getMatches() {
    return axios.get(API_URL + "matches", { headers: authHeader() });
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
  getAllBets() {
    return axios.get(API_URL + "bets", { headers: authHeader() });
  }
  getPokemon(name) {
    return axios.get(API_URL + "pokemon/" + name, { headers: authHeader() });
  }
  getAllTransactions() {
    return axios.get(API_URL + "transaction", { headers: authHeader() });
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
}

export default new ApiSerivce();
