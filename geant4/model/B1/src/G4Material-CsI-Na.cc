#include "G4Material-CsI-Na.hh"

G4Material* getCsI_Na() {

  G4String name;//, symbol;
  G4double density;
  //G4int iz, n;

  G4int ncomponents, natoms;
  G4double fractionmass;
  //G4double temperature, pressure;

  // define properties of Cs, I and Na
  G4NistManager* manager = G4NistManager::Instance();
  G4Element* elCs = manager->FindOrBuildElement("Cs");
  G4Element* elI = manager->FindOrBuildElement("I");
  G4Element* elNa = manager->FindOrBuildElement("Na");

  // define CsI
  density = 4.51*g/cm3;   // density of CsI according to Haynes
  G4Material* CsI = new G4Material(name="CsI", density, ncomponents=2);
  CsI->AddElement(elCs, natoms=1);
  CsI->AddElement(elI, natoms=1);

  // define doped material
  density = 4.51*g/cm3;   // density of CsI(Na) according to Saint-Gobain
  G4Material* CsI_Na = new G4Material(name="CsI(Na)", density, ncomponents=2);
  CsI_Na->AddMaterial(CsI, fractionmass=99.98*perCent);
  CsI_Na->AddElement(elNa, fractionmass=0.02*perCent);
  // 0.02% concentration according to https://arxiv.org/pdf/1612.06071.pdf p.2

  G4cout << CsI_Na;
  G4cout << *(G4Material::GetMaterialTable());

  return CsI_Na;

}
