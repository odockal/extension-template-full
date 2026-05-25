<script lang="ts">
import './app.css';
import '@fortawesome/fontawesome-free/css/all.min.css';
import { router } from 'tinro';
import Route from './lib/Route.svelte';
import { onMount } from 'svelte';
import { getRouterState } from './api/client';

router.mode.hash();
let isMounted = false;

onMount(() => {
  const state = getRouterState();
  router.goto(state.url || '/chaos');
  isMounted = true;
});
</script>

<Route path="/*" breadcrumb="Chaos Lab" isAppMounted={isMounted} let:meta>
  <main class="flex flex-col w-screen h-screen overflow-hidden bg-[var(--pd-content-bg)]">
    <div class="flex flex-row w-full h-full overflow-hidden">
      <div class="flex flex-col w-full h-full overflow-hidden">
        <Route path="/" breadcrumb="Dashboard">
          <div class="flex items-center justify-center h-full text-[var(--pd-content-text)]">
            Chaos Lab Dashboard
          </div>
        </Route>
        <Route path="/chaos" breadcrumb="Dashboard">
          <div class="flex items-center justify-center h-full text-[var(--pd-content-text)]">
            Chaos Lab Dashboard
          </div>
        </Route>
      </div>
    </div>
  </main>
</Route>
