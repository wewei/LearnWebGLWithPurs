import './index.css';
import { main } from '../output/Main';

document.querySelector('#root').innerHTML = `
<div class="content">
  <h1>Vanilla Rsbuild</h1>
  <p>Start building amazing things with Rsbuild.</p>
</div>
`;

main();