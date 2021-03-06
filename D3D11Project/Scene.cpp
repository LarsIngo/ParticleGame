#include "Scene.hpp"
#include "StorageSwapBuffer.hpp"

Scene::Scene(ID3D11Device* pDevice, ID3D11DeviceContext* pDeviceContext, unsigned int maxParticleCount)
{
    mpDevice = pDevice;
    mpDeviceContext = pDeviceContext;
    mParticleCount = 0;
    mMaxParticleCount = maxParticleCount;

    mParticleBuffer = new StorageSwapBuffer(mpDevice, mpDeviceContext, sizeof(Particle) * mMaxParticleCount, sizeof(Particle));
}

Scene::~Scene()
{
    delete mParticleBuffer;
}

void Scene::AddParticles(std::vector<Particle>& particleList)
{
    unsigned int offset = mParticleCount * sizeof(Particle);
    unsigned int particleCount = (unsigned int)particleList.size();
    unsigned int bytes = particleCount * sizeof(Particle);

    mParticleBuffer->GetInputBuffer()->Write(particleList.data(), bytes, offset);

    mParticleCount += particleCount;
}
