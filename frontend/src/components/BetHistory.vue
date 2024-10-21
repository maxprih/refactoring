<template>
    <div style="margin-top: 30px;" data-bs-theme="dark">
        <div v-for="bet in bets.reverse()" :key="bet.id" class="card mb-3">
            <div class="card text-center text-white" style="background-color: #262630;">
                <div class="card-header text-muted d-flex flex-row align-items-center justify-content-between">
                    <div class="h3">№{{ bet.id }}</div>
                    <div class="h3 me-auto values">{{ bet.date }}</div>
                    <div class="h3">{{ bet.coefficient.toFixed(2) }}</div>
                </div>
                <div class="card-body">
                    <div class="d-flex flex-row" v-for="matchEvent in bet.matchEvents" :key="matchEvent.name">
                        <div class="h3">{{ matchEvent.matchFirstPlayerName }} – {{ matchEvent.matchSecondPlayerName }}</div>
                        <div class="h3 me-auto values">{{ matchEvent.name }}</div>
                        <div class="h3 values" :class="statusColorClass(matchEvent.status)">{{ matchEvent.status }}</div>
                        <div class="h3 values">{{ matchEvent.coefficient }}</div>
                    </div>
                </div>
                <div class="card-footer d-grid">
                    <div class="d-flex flex-row" data-bs-theme="dark">
                        <div class="h3 me-auto">Cумма: {{ bet.amount }}</div>
                        <div class="h3">Статус: <span :class="statusColorClass(bet.status)">{{ bet.status }}</span></div>
                        <div class="h3 values">Итог: <span :class="statusColorClass(bet.status)">{{ bet.winnings }}</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import apiService from '../services/api.service';

export default {
    name: "BetHistory",

    data() {
        return {
            bets: []
        }
    },
    methods: {
        getAllBets() {
            apiService.getAllBets()
                .then(response => {
                    this.bets = response.data;
                })
        },
        statusColorClass(status) {
            switch (status) {
                case 'TBD':
                    return 'text-yellow';
                case 'WIN':
                    return 'text-green';
                case 'LOSE':
                    return 'text-red';
                default:
                    return '';
            }
        },
    },
    mounted() {
        this.$store.dispatch('auth/update');
        this.getAllBets();
    }
}
</script>

<style>
.values {
    margin-left: 20px;
}

.text-yellow {
    color: yellow !important;
}

.text-green {
    color: green !important;
    ;
}

.text-red {
    color: red !important;
    ;
}
</style>