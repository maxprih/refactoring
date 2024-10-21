<template>
    <div data-bs-theme="dark" class="modal fade" id="modal1" tabindex="-1" aria-labelledby="modal1label" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered ">
            <div class="modal-content">
                <div class="modal-header">
                    <h1 class="modal-title" id="modal1label" style="text-align:center">{{ pokemon1.name }}</h1>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div style="display:flex;">
                        <div>
                            <ul class="list-group h2" style="width:fit-content" data-bs-theme="dark">
                                <li class="list-group-item d-flex align-items-center">
                                    <strong>Здоровье:</strong>
                                    <span class="values">{{ pokemon1.health }}</span>
                                </li>
                                <li class="list-group-item d-flex align-items-center">
                                    <strong>Атака:</strong>
                                    <span class="values">{{ pokemon1.damage }}</span>
                                </li>
                                <li class="list-group-item d-flex align-items-center">
                                    <strong>Защита:</strong>
                                    <span class="values">{{ pokemon1.defense }}</span>
                                </li>
                                <li class="list-group-item d-flex align-items-center">
                                    <strong>Страна:</strong>
                                    <span class="values">{{ pokemon1.countryName }}</span>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
    <div data-bs-theme="dark" class="modal fade" id="modal2" tabindex="-1" aria-labelledby="modal2label" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered ">
            <div class="modal-content">
                <div class="modal-header">
                    <h1 class="modal-title" id="modal2label" style="text-align:center">{{ pokemon2.name }}</h1>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div style="display:flex;">
                        <div>
                            <ul class="list-group h2" style="width:fit-content" data-bs-theme="dark">
                                <li class="list-group-item d-flex align-items-center">
                                    <strong>Здоровье:</strong>
                                    <span class="values">{{ pokemon2.health }}</span>
                                </li>
                                <li class="list-group-item d-flex align-items-center">
                                    <strong>Атака:</strong>
                                    <span class="values">{{ pokemon2.damage }}</span>
                                </li>
                                <li class="list-group-item d-flex align-items-center">
                                    <strong>Защита:</strong>
                                    <span class="values">{{ pokemon2.defense }}</span>
                                </li>
                                <li class="list-group-item d-flex align-items-center">
                                    <strong>Страна:</strong>
                                    <span class="values">{{ pokemon2.countryName }}</span>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
    <div class="position-absolute start-50 w-50 translate-middle-x">
        <div class="d-flex flex-row justify-content-between align-items-center rounded-rectangle text-center">
            <img src="../assets/logo.png" alt="" style="height: 4em;">
            <div class="h2" style="width: 25%;">
                <span class="hovered-text" data-bs-toggle="modal" data-bs-target="#modal1">{{ match.firstPlayerName
                }}</span>
            </div>
            <div class="h3" style="width: 25%;">{{ match.date }}</div>
            <div class="h2" style="width: 25%;">
                <span class="hovered-text" data-bs-toggle="modal" data-bs-target="#modal2">{{ match.secondPlayerName
                }}</span>
            </div>
            <img src="../assets/logo.png" alt="" style="height: 4em;">
        </div>

        <div>
            <template v-for="(row, index) in groupedMatchEvents" :key="index">
                <div class="d-flex flex-column justify-content-around align-items-center rounded-rectangle">
                    <template v-for="matchEvent in row" :key="matchEvent.id">
                        <input type="checkbox" :id="'btncheck' + matchEvent.id" class="btn-check" autocomplete="off"
                            @click="toggleCheckbox(matchEvent)" :checked="isSelected(matchEvent)" />
                        <label style="margin-top: 30px;" :for="'btncheck' + matchEvent.id"
                            class="btn btn-coeffs text-white hovered">
                            {{ matchEvent.name }} <br /> {{ matchEvent.coefficient }}
                            <div v-if="isAdmin">
                                <p>Текущий статус: {{ matchEvent.status }}</p>
                                <div class="d-flex flex-row align-items-center justify-content-around">
                                    <label>
                                        <input checked type="radio" :id="'tbdRadio' + matchEvent.id"
                                            v-model="matchEvent.status" value="TBD"
                                            @change="handleStatusChange(matchEvent)" />
                                        TBD
                                    </label>
                                    <label>
                                        <input type="radio" :id="'winRadio' + matchEvent.id" v-model="matchEvent.status"
                                            value="WIN" @change="handleStatusChange(matchEvent)" />
                                        Win
                                    </label>
                                    <label>
                                        <input type="radio" :id="'loseRadio' + matchEvent.id" v-model="matchEvent.status"
                                            value="LOSE" @change="handleStatusChange(matchEvent)" />
                                        Lose
                                    </label>
                                </div>

                                <button style="margin-top:10px;" @click="changeEventStatus(matchEvent)"
                                    class="btn btn-outline-success" type="button" id="button-addon2">Изменить
                                    статус</button>
                            </div>
                        </label>
                    </template>
                </div>
            </template>
        </div>
    </div>
</template>
<script>
import ApiSerivce from "../services/api.service";

export default {
    name: "Match",
    data() {
        return {
            match_id: this.$route.params.id,
            match: "",
            pokemon1: "",
            pokemon2: "",
            match_events: [],
            chunkedMatchEvents: [],
            elementsPerRow: 3
        };
    },
    methods: {
        getMatch() {
            ApiSerivce.getMatchById(this.match_id)
                .then(response => {
                    this.match = response.data;
                    this.match_events = this.match.matchEvents;
                })
        },
        toggleCheckbox(matchEvent) {
            if (this.isSelected(matchEvent)) {
                this.$store.dispatch('events/removeEvent', matchEvent);
            } else {
                this.$store.dispatch('events/addEvent', matchEvent);
            }
        },
        isSelected(matchEvent) {
            return this.selectedEvents.some((event) => event.id === matchEvent.id);
        },
        getPokemons() {
            ApiSerivce.getPokemon(this.match.firstPlayerName)
                .then(response => {
                    this.pokemon1 = response.data
                })
            ApiSerivce.getPokemon(this.match.secondPlayerName)
                .then(response => {
                    this.pokemon2 = response.data
                })
        },
        changeEventStatus(matchEvent) {
            ApiSerivce.changeEventStatus(matchEvent.id, matchEvent.status)
        }
    },
    computed: {
        selectedEvents() {
            return this.$store.getters['events/getSelectedEvents'];
        },
        groupedMatchEvents() {
            const rows = [];
            for (let i = 0; i < this.match_events.length; i += this.elementsPerRow) {
                rows.push(this.match_events.slice(i, i + this.elementsPerRow));
            }
            return rows;
        },
        isAdmin() {
            return (this.$store.state.auth.user.roles).some(role => role.roleName === "ROLE_ADMIN");
        }
    },
    mounted() {
        this.getMatch();
        setTimeout(() => {
            this.getPokemons();
        }, 500);
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

li>button {
    margin-left: 100px;
}

.btn-coeffs {
    background-color: #3f3f4c !important;
    width: 50%;
}

.hovered {
    transition: 0.5s box-shadow;
}

.hovered:hover {
    box-shadow: 0 5px 35px 0px white;
}

.hovered-text {
    transition: 0.5s box-shadow;
}

.hovered-text:hover {
    box-shadow: 0 5px 15px 0px red;
}
</style>