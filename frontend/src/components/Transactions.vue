<template>
    <div style="margin-top: 30px;" data-bs-theme="dark">
        <div v-for="transaction in transactions.reverse()" :key="transaction.id" class="card mb-3">
            <div class="card text-center text-white" style="background-color: #262630;">
                <div class="card-header text-muted d-flex flex-row align-items-center justify-content-between">
                    <div class="h3">№{{ transaction.id }}</div>
                    <div class="h3 me-auto values">{{ transaction.date }}</div>
                </div>
                <div class="card-footer d-grid">
                    <div class="d-flex flex-row" data-bs-theme="dark">
                        <div class="h3 me-auto">Cумма: {{ transaction.amount }}</div>
                        <div class="h3">Тип: <span :class="statusColorClass(transaction.type)">{{ transaction.type }}</span>
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
    name: "Transactions",

    data() {
        return {
            transactions: []
        }
    },
    methods: {
        getAllTransactions() {
            apiService.getAllTransactions()
                .then(response => {
                    this.transactions = response.data;
                })
        },
        statusColorClass(status) {
            switch (status) {
                case 'Пополнение':
                    return 'text-green';
                case 'Убыток':
                    return 'text-red';
                default:
                    return '';
            }
        },
    },
    mounted() {
        this.$store.dispatch('auth/update');
        this.getAllTransactions();
    },
    computed: {

    }
}
</script>

<style>
.values {
    margin-left: 20px;
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