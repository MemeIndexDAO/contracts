import { Blockchain, SandboxContract, TreasuryContract } from '@ton/sandbox';
import { toNano } from '@ton/core';
import { Season } from '../wrappers/Season';
import '@ton/test-utils';

describe('Season', () => {
    let blockchain: Blockchain;
    let deployer: SandboxContract<TreasuryContract>;
    let season: SandboxContract<Season>;

    beforeEach(async () => {
        blockchain = await Blockchain.create();

        season = blockchain.openContract(await Season.fromInit());

        deployer = await blockchain.treasury('deployer');

        const deployResult = await season.send(
            deployer.getSender(),
            {
                value: toNano('0.05'),
            },
            {
                $$type: 'Deploy',
                queryId: 0n,
            }
        );

        expect(deployResult.transactions).toHaveTransaction({
            from: deployer.address,
            to: season.address,
            deploy: true,
            success: true,
        });
    });

    it('should deploy', async () => {
        // the check is done inside beforeEach
        // blockchain and season are ready to use
    });
});
