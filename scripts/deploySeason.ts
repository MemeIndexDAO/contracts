import { toNano } from '@ton/core';
import { Season } from '../wrappers/Season';
import { NetworkProvider } from '@ton/blueprint';

export async function run(provider: NetworkProvider) {
    const season = provider.open(await Season.fromInit());

    await season.send(
        provider.sender(),
        {
            value: toNano('0.05'),
        },
        {
            $$type: 'Deploy',
            queryId: 0n,
        }
    );

    await provider.waitForDeploy(season.address);

    // run methods on `season`
}
